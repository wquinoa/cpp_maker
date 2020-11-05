/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   uninstall.hpp                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: wquinoa <wquinoa@student.21-school.ru>     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/11/06 02:12:08 by wquinoa           #+#    #+#             */
/*   Updated: 2020/11/06 02:12:08 by wquinoa          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef UNINSTALL_HPP
# define UNINSTALL_HPP
# include <iostream>

class uninstall
{
public:
	uninstall();
	uninstall(const uninstall &copy);
	~uninstall();
	uninstall &operator=(const uninstall &copy);

private:
};

#endif
