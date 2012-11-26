From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH 3/6 -v3] libext2fs: add ext2fs_bitcount() function
Date: Mon, 26 Nov 2012 15:17:45 -0800
Message-ID: <20121126231745.GH23854@lenny.home.zabbo.net>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
 <1353947981-15219-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:59398 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab2KZXRq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 18:17:46 -0500
Content-Disposition: inline
In-Reply-To: <1353947981-15219-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This function efficiently counts the number of bits in a block of
> memory.

Would it be worth the annoying build- and run-time machinery to detect
and use the -msse4.2 __builtin_popcount() gcc intrinsic?

> +static unsigned int popcount32(unsigned int w)
> +{
> +	unsigned int res = w - ((w >> 1) & 0x55555555);
> +	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
> +	res = (res + (res >> 4)) & 0x0F0F0F0F;
> +	res = res + (res >> 8);
> +	return (res + (res >> 16)) & 0x000000FF;
> +}

  40042b:       89 c2                   mov    %eax,%edx
  400432:       d1 ea                   shr    %edx
  400434:       81 e2 55 55 55 55       and    $0x55555555,%edx
  40043a:       29 d0                   sub    %edx,%eax
  40043c:       89 c2                   mov    %eax,%edx
  40043e:       c1 e8 02                shr    $0x2,%eax
  400441:       81 e2 33 33 33 33       and    $0x33333333,%edx
  400447:       25 33 33 33 33          and    $0x33333333,%eax
  40044c:       01 d0                   add    %edx,%eax
  40044e:       89 c2                   mov    %eax,%edx
  400450:       c1 ea 04                shr    $0x4,%edx
  400453:       01 d0                   add    %edx,%eax
  400455:       25 0f 0f 0f 0f          and    $0xf0f0f0f,%eax
  40045a:       89 c2                   mov    %eax,%edx
  40045c:       c1 ea 08                shr    $0x8,%edx
  40045f:       01 d0                   add    %edx,%eax
  400461:       89 c6                   mov    %eax,%esi
  400463:       c1 ee 10                shr    $0x10,%esi
  400468:       0f b6 f0                movzbl %al,%esi

__builtin_popcount():

  40047e:       f3 0f b8 f0             popcnt %eax,%esi

- z
