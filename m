From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: File permissions in ext4
Date: Thu, 01 Aug 2013 16:59:40 +0400
Message-ID: <1375361980.2304.4.camel@slavad-ubuntu>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
	 <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:47989 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750834Ab3HAM7w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 08:59:52 -0400
In-Reply-To: <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2013-08-01 at 14:34 +0200, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> Ok, I found that the permissions that I was looking for are stored in
> ext4_inode.i_mode ... but still there is the question: What is ACL
> used for then, and when is it different than zero?
> 

Do you build the kernel with POSIX ACLs support
(CONFIG_EXT4_FS_POSIX_ACL)?

With the best regards,
Vyacheslav Dubeyko.


