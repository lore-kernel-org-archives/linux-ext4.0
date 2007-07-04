From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Wed, 4 Jul 2007 10:44:32 -0600
Message-ID: <20070704164432.GN6578@schatzie.adilger.int>
References: <1183275416.4010.125.camel@localhost.localdomain> <1183458506.4102.5.camel@garfield.linsyssoft.com> <1183519975.3922.7.camel@localhost.localdomain> <468B3FDA.7060809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, Kalpak Shah <kalpak@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <468B3FDA.7060809@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 04, 2007  12:06 +0530, Aneesh Kumar K.V wrote:
> Mingming Cao wrote:
> >On Tue, 2007-07-03 at 15:58 +0530, Kalpak Shah wrote:
> >>On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
> >>>+
> >>>+#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)		 \
> >>>+do {								 \
> >>>+	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	    
> >>>\
> >>>+	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))  
> >>>\
> >>>+		ext4_decode_extra_time(&(inode)->xtime,			    
> >>>\
> >>>+				       raw_inode->xtime ## _extra);	    
> >>>\
> >>>+} while (0)
> >>>+
> >>>+#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)		 \
> >>>+do {								 \
> >>>+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		    
> >>>\
> >>>+		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);   
> >>>\
> >>>+	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	    
> >>>\
> >>>+		ext4_decode_extra_time(&(einode)->xtime,		    
> >>>\
> >>>+				       raw_inode->xtime ## _extra);	    
> >>>\
> >>>+} while (0)
> >>>+
> >>This nanosecond patch seems to be missing the fix below which is 
> >>required for http://bugzilla.kernel.org/show_bug.cgi?id=5079
> >>
> >>If the timestamp is set to before epoch i.e. a negative timestamp then 
> >>the file may have its date set into the future on 64-bit systems. So 
> >>when the timestamp is read it must be cast as signed.
> >
> >Missed this one.
> >Thanks. Will update ext4 patch queue tonight with this fix.
> 
> IIRC in the conference call it was decided to not to apply this patch. 
> Andreas may be able to update better.

I wasn't on the most recent concall, and I've forgotten the details of
any discussion on a previous concall.

Care really needs to be taken here that negative timestamps are handled
properly.  We can take the sign bit from the inode i_*time, but then we
need to change the load/save of the extra time to use a shift of 31
instead of 32.  If we overflow the epoch we have to ensure that the high
bits of the seconds is handled correctly.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

