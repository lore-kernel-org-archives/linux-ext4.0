From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and
	powerpc
Date: Wed, 09 May 2007 10:07:25 -0700
Message-ID: <1178730446.3815.8.camel@dyn9047017103.beaverton.ibm.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com>
	 <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426180332.GA7209@amitarora.in.ibm.com>
	 <20070509160102.GA30745@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:39029 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbXEIRHa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 13:07:30 -0400
In-Reply-To: <20070509160102.GA30745@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-05-09 at 21:31 +0530, Amit K. Arora wrote:
> I have the updated patches ready which take care of Andrew's comments.
> Will run some tests and post them soon.
> 
> But, before submitting these patches, I think it will be better to finalize
> on certain things which might be worth some discussion here:
> 
> 1) Should the file size change when preallocation is done beyond EOF ?
>    - Andreas and Chris Wedgwood are in favor of not changing the
>      file size in this case. I also tend to agree with them. Does anyone
>      has an argument in favor of changing the filesize ?
>      If not, I will remove the code which changes the filesize, before I
>      resubmit the concerned ext4 patch.
> 

If we chose not to update the file size beyong EOF, then for filesystem
without fallocate() support (ext2,3 currently), posix_fallocate() will
follow the hard way(zero-out) to do preallocation. Then we will get
different behavior on filesystems w/o fallocate() support. It make sense
to be consistent, IMO.

My point of view, preallocation is just a efficient way to allocating
blocks for files without zero-out, other than this, the new behavior
should be consistent with the old way: file size update,mtime/ctime,
ENOSPC etc.

Mingming
