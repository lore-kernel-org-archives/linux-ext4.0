From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] ext4: FLEX_BG Kernel support v2.
Date: Fri, 21 Sep 2007 15:49:35 -0500
Message-ID: <20070921154935.0b16c5ca@gara>
References: <20070921140649.4352.30055.stgit@toolssf2>
	<1190406567.13955.1.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44108 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764318AbXIUUtc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2007 16:49:32 -0400
In-Reply-To: <1190406567.13955.1.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 21 Sep 2007 13:29:27 -0700
Badari Pulavarty <pbadari@gmail.com> wrote:

> On Fri, 2007-09-21 at 09:06 -0500, Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > ext4: FLEX_BG Kernel support v2.
> > 
> 
> > @@ -702,13 +702,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
> >  #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
> >  #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
> >  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
> > +#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
> 
> Any reason why 0x100 is skipped ?
> 
> Thanks,
> Badari
> 

Because 0x0100 is reserved for EXT4_FEATURE_INCOMPAT_MMP in e2fsprogs.

-JRS
