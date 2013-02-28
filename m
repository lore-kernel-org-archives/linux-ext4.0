From: Tomas Racek <tracek@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix flag settings in e2image.h
Date: Thu, 28 Feb 2013 15:11:28 -0500 (EST)
Message-ID: <1461721458.4319660.1362082288072.JavaMail.root@redhat.com>
References: <alpine.LFD.2.00.1302211356490.19354@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54151 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3B1UL2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 15:11:28 -0500
In-Reply-To: <alpine.LFD.2.00.1302211356490.19354@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message -----
> On Thu, 21 Feb 2013, Tomas Racek wrote:
> 
> > Date: Thu, 21 Feb 2013 13:06:58 +0100
> > From: Tomas Racek <tracek@redhat.com>
> > To: linux-ext4@vger.kernel.org
> > Cc: Tomas Racek <tracek@redhat.com>
> > Subject: [PATCH] e2fsprogs: fix flag settings in e2image.h
> > 
> > This prevents from SIGSEGV when -s options is used.
> 
> oops! Thanks for catching that. I just wonder why the regression
> test is not catching that ?

Well, it seems that "-s" option is not tested (or even used). I'll try to fix at least the first thing. ;-)

Tom

> 
> 
> you can add
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> > 
> > Signed-off-by: Tomas Racek <tracek@redhat.com>
> > ---
> >  lib/ext2fs/e2image.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/ext2fs/e2image.h b/lib/ext2fs/e2image.h
> > index c918529..5537980 100644
> > --- a/lib/ext2fs/e2image.h
> > +++ b/lib/ext2fs/e2image.h
> > @@ -19,7 +19,7 @@
> >  /* Image flags */
> >  #define E2IMAGE_INSTALL_FLAG	1
> >  #define E2IMAGE_SCRAMBLE_FLAG	2
> > -#define E2IMAGE_IS_QCOW2_FLAG	3
> > +#define E2IMAGE_IS_QCOW2_FLAG	4
> >  
> >  struct ext2_image_hdr {
> >  	__u32	magic_number;	/* This must be EXT2_ET_MAGIC_E2IMAGE */
> > 
> 
