From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: File permissions in ext4
Date: Thu, 1 Aug 2013 15:23:45 +0200
Message-ID: <CACyNnZM9Fm8s+3Eg-yL3bd0KSbZNvPCmUWEBrETCUdj_RMwnwg@mail.gmail.com>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
	<CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
	<1375361980.2304.4.camel@slavad-ubuntu>
	<CACyNnZNdVo73TUhaMsx8j7kZq=M65XEMzwmWCi4M7Js0G0k4TA@mail.gmail.com>
	<1375363302.2304.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: slava@dubeyko.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42347 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3HANXq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 09:23:46 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so847621pbb.34
        for <linux-ext4@vger.kernel.org>; Thu, 01 Aug 2013 06:23:46 -0700 (PDT)
In-Reply-To: <1375363302.2304.9.camel@slavad-ubuntu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 1, 2013 at 3:21 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
> config EXT4_FS_POSIX_ACL
>           POSIX Access Control Lists (ACLs) support permissions for users and
>           groups beyond the owner/group/world scheme.
>
>           To learn more about Access Control Lists, visit the POSIX ACLs for
>           Linux website <http://acl.bestbits.at/>.

Aha, so it is just a more advanced version of the permissions. But I
suppose that i_mode will always be valid even if the file system also
support ACL, correct?

-- 
Felipe Monteiro de Carvalho
