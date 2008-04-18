From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
Date: Fri, 18 Apr 2008 12:26:47 -0700
Message-ID: <1208546807.9475.4.camel@localhost.localdomain>
References: <48089B86.5020108@hitachi.com>
	 <20080418140946.GA26062@unused.rdu.redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761046AbYDRT1A@vger.kernel.org>
In-Reply-To: <20080418140946.GA26062@unused.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-04-18 at 10:09 -0400, Josef Bacik wrote:
> On Fri, Apr 18, 2008 at 10:00:54PM +0900, Hidehiro Kawai wrote:
> > Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
> > 
> > The current JBD is not sufficient for I/O error handling.  It can
> > cause filesystem corruption.   An example scenario:
> > 
> > 1. fail to write a metadata buffer to block B in the journal
> > 2. succeed to write the commit record
> > 3. the system crashes, reboots and mount the filesystem
> > 4. in the recovery phase, succeed to read data from block B
> > 5. write back the read data to the filesystem, but it is a stale
> >    metadata
> > 6. lose some files and directories!
> > 
> > This scenario is a rare case, but it (temporal I/O error)
> > can occur.  If we abort the journal between 1. and 2., this
> > tragedy can be avoided.
> > 
> > This patch set fixes several error handling problems to protect
> > from filesystem corruption caused by I/O errors.  It has been
> > done only for JBD and ext3 parts.
> >
> 

Could you sent Ext4/JBD2 version patches? Thanks!

> There doesn't seem like much point in taking these patches as Jan is rewriting
> the ordered mode path and most of these functions will be going away soon.
> Those patches seem like they will be coming soon and will obsolete these.
> 

I hope we have a better ordered mode very soon too. Just thought it's
still valid to fix the current ordered mode for people who uses
linux-2.6.25 kernel today. 

Mingming
> Josef 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
