/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   class1.hpp                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: wquinoa <wquinoa@student.21-school.ru>     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/09/28 00:31:36 by wquinoa           #+#    #+#             */
/*   Updated: 2020/09/28 00:31:36 by wquinoa          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef CLASS1_HPP
# define CLASS1_HPP
# include <iostream>

class class1
{
public:
	class1();
	class1(const class1 &copy);
	~class1();
	class1 &operator=(const class1 &copy);

private:
};

#endif
