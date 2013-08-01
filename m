From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: File permissions in ext4
Date: Thu, 01 Aug 2013 17:35:10 +0400
Message-ID: <1375364110.2304.11.camel@slavad-ubuntu>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
	 <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
	 <1375361980.2304.4.camel@slavad-ubuntu>
	 <CACyNnZNdVo73TUhaMsx8j7kZq=M65XEMzwmWCi4M7Js0G0k4TA@mail.gmail.com>
	 <1375363302.2304.9.camel@slavad-ubuntu>
	 <CACyNnZM9Fm8s+3Eg-yL3bd0KSbZNvPCmUWEBrETCUdj_RMwnwg@mail.gmail.com>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36575 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755177Ab3HANfR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 09:35:17 -0400
In-Reply-To: <CACyNnZM9Fm8s+3Eg-yL3bd0KSbZNvPCmUWEBrETCUdj_RMwnwg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2013-08-01 at 15:23 +0200, Felipe Monteiro de Carvalho wrote:
> On Thu, Aug 1, 2013 at 3:21 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
> > config EXT4_FS_POSIX_ACL
> >           POSIX Access Control Lists (ACLs) support permissions for users and
> >           groups beyond the owner/group/world scheme.
> >
> >           To learn more about Access Control Lists, visit the POSIX ACLs for
> >           Linux website <http://acl.bestbits.at/>.
> 
> Aha, so it is just a more advanced version of the permissions. But I
> suppose that i_mode will always be valid even if the file system also
> support ACL, correct?
> 

As I understand, yes. Because ACLs are simply enhancement of permission
model.

With the best regards,
Vyacheslav Dubeyko.


