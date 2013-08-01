From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: File permissions in ext4
Date: Thu, 01 Aug 2013 12:27:56 -0500
Message-ID: <51FA9A9C.1090301@redhat.com>
References: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com> <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3HAR17 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 13:27:59 -0400
In-Reply-To: <CACyNnZM51RDcyzah_nbQA+tSYDVAXsduzDkGAK-gjfBfo1NWDg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/1/13 7:34 AM, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> Ok, I found that the permissions that I was looking for are stored in
> ext4_inode.i_mode ... but still there is the question: What is ACL
> used for then, and when is it different than zero?
> 
> thanks =)
> 

It is the block number containing an extended attribute for that inode,
if any; that extended attribute may be a file ACL.

It's a bit odd to call the xattr block "ACL" but it is what it is.  ;)

-Eric
