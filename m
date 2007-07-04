From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Tue, 03 Jul 2007 23:32:55 -0400
Message-ID: <1183519975.3922.7.camel@localhost.localdomain>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <1183458506.4102.5.camel@garfield.linsyssoft.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53499 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbXGDGcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2007 02:32:54 -0400
In-Reply-To: <1183458506.4102.5.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-03 at 15:58 +0530, Kalpak Shah wrote:
> On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
> > +
> > +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
> > +do {									       \
> > +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
> > +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> > +		ext4_decode_extra_time(&(inode)->xtime,			       \
> > +				       raw_inode->xtime ## _extra);	       \
> > +} while (0)
> > +
> > +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
> > +do {									       \
> > +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
> > +		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
> > +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
> > +		ext4_decode_extra_time(&(einode)->xtime,		       \
> > +				       raw_inode->xtime ## _extra);	       \
> > +} while (0)
> > +
> 
> This nanosecond patch seems to be missing the fix below which is required for http://bugzilla.kernel.org/show_bug.cgi?id=5079
> 
> If the timestamp is set to before epoch i.e. a negative timestamp then the file may have its date set into the future on 64-bit systems. So when the timestamp is read it must be cast as signed.

Missed this one.
Thanks. Will update ext4 patch queue tonight with this fix.

Mingming
