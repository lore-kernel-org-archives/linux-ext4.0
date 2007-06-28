From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Date: Thu, 28 Jun 2007 11:33:42 -0700
Message-ID: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
References: <20070510223950.GD86004887@sgi.com>
	<20070511110301.GB28425@in.ibm.com>
	<20070512080157.GF85884050@sgi.com>
	<20070612061652.GA6320@amitarora.in.ibm.com>
	<20070613235217.GS86004887@sgi.com>
	<20070614091458.GH5181@schatzie.adilger.int>
	<20070614120413.GD86004887@sgi.com>
	<20070614193347.GN5181@schatzie.adilger.int>
	<20070625132810.GA1951@amitarora.in.ibm.com>
	<20070628025543.9467216f.akpm@linux-foundation.org>
	<20070628175757.GA1674@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
	cmm@us.ibm.com, xfs@oss.sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765581AbXF1SeV@vger.kernel.org>
In-Reply-To: <20070628175757.GA1674@amitarora.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 28 Jun 2007 23:27:57 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> > Please drop the non-ext4 patches from the ext4 tree and send incremental
> > patches against the (non-ext4) fallocate patches in -mm.
> 
> Please let us know what you think of Mingming's suggestion of posting
> all the fallocate patches including the ext4 ones as incremental ones
> against the -mm.

I think Mingming was asking that Ted move the current quilt tree into git,
presumably because she's working off git.

I'm not sure what to do, really.  The core kernel patches need to be in
Ted's tree for testing but that'll create a mess for me.

ug.

Options might be

a) I drop the fallocate patches from -mm and from the ext4 tree, hack up
   any needed build fixes, then just wait for it all to mature and then
   think about it again

b) We do what we normally don't do and reserve the syscall slots in mainline.
