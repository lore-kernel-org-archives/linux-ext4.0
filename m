From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Fri, 13 Jul 2007 14:46:58 -0700
Message-ID: <1184363218.16045.0.camel@localhost.localdomain>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <20070710163027.1bf7e94e.akpm@linux-foundation.org>
	 <1184245126.4299.20.camel@garfield>  <4696FFBE.3030806@linux.vnet.ibm.com>
	 <1184310318.4372.5.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1184310318.4372.5.camel@garfield>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-13 at 12:35 +0530, Kalpak Shah wrote:
> On Fri, 2007-07-13 at 09:59 +0530, Aneesh Kumar K.V wrote:
> > 
> > Kalpak Shah wrote:
> > > On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> > >> On Sun, 01 Jul 2007 03:36:56 -0400
> > >> Mingming Cao <cmm@us.ibm.com> wrote:
> > >>
> > >>> This patch is a spinoff of the old nanosecond patches.
> > >> I don't know what the "old nanosecond patches" are.  A link to a suitable
> > >> changlog for those patches would do in a pinch.  Preferable would be to
> > >> write a proper changelog for this patch.
> > > 
> > > The incremental patch contains a proper changelog describing the patch.
> > > 
> > 
> > 
> > Instead of  putting incremental patches it would be nice if we can have replacement patches.
> > for the already existing patches with the comments addressed. For example if we have a 
> > review comment on the patch message ( commit log ) then adding an incremental patch doesn't help.
> 
> I think that it would be easier to review just the changes that have
> been made to the patches instead of having people go through the entire
> patch again. I was hoping that someone with write access to ext4-git
> would update the commit logs.
> 
> If replacement patches are preferred, then I will send them again.
> 

No need, I already fold your fix patch to the parent patches, so in the
updated ext4-patch-queue it saved the updated nanosecond patch.

> Thanks,
> Kalpak.
> 
> > 
> > 
> > -aneesh
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

