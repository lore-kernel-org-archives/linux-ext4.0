From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: File permissions in ext4
Date: Thu, 01 Aug 2013 17:21:42 +0400
Message-ID: <1375363302.2304.9.camel@slavad-ubuntu>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
	 <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
	 <1375361980.2304.4.camel@slavad-ubuntu>
	 <CACyNnZNdVo73TUhaMsx8j7kZq=M65XEMzwmWCi4M7Js0G0k4TA@mail.gmail.com>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44165 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752414Ab3HANVr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 09:21:47 -0400
In-Reply-To: <CACyNnZNdVo73TUhaMsx8j7kZq=M65XEMzwmWCi4M7Js0G0k4TA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2013-08-01 at 15:09 +0200, Felipe Monteiro de Carvalho wrote:
> On Thu, Aug 1, 2013 at 2:59 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
> > Do you build the kernel with POSIX ACLs support
> > (CONFIG_EXT4_FS_POSIX_ACL)?
> 
> Anyway to find out this? I am using the pre-compiled kernel which
> comes with Mageia Linux ... so I did not compile the kernel myself.
> 

You can check it in your kernel configuration file. Ubuntu stores such
files in /boot/config-<kernel-version>.

Anyway, I think that this quotation from fs/ext4/Kconfig can be helpful
for you:

config EXT4_FS_POSIX_ACL
	bool "Ext4 POSIX Access Control Lists"
	depends on EXT4_FS
	select FS_POSIX_ACL
	help
	  POSIX Access Control Lists (ACLs) support permissions for users and
	  groups beyond the owner/group/world scheme.

	  To learn more about Access Control Lists, visit the POSIX ACLs for
	  Linux website <http://acl.bestbits.at/>.

	  If you don't know what Access Control Lists are, say N

With the best regards,
Vyacheslav Dubeyko.


