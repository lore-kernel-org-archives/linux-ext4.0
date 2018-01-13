From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/8] Ext4 encryption support for blocksize < pagesize
Date: Sat, 13 Jan 2018 10:58:00 +0530
Message-ID: <4200254.IvU45QXq6O@localhost.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com> <1aa4981a-63ef-aaa4-97da-9c9137d52862@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1aa4981a-63ef-aaa4-97da-9c9137d52862@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday, January 13, 2018 12:37:59 AM IST Randy Dunlap wrote:
> On 01/12/18 06:11, Chandan Rajendra wrote:
> > This patchset implements code to support encryption of Ext4 filesystem
> > instances that have blocksize less than pagesize. The patchset has
> > been tested on both ppc64 and x86_64 machines.
> 
> strictly "less than" or "less than or equal to"?

I have tested the patchset for the use cases of "less than or equal to
page size" i.e. On ppc64, the patchset was tested with blocksizes of 
4k and 64k. On x86_64, the patchset was tested with blocksizes of 2k 
and 4k.

-- 
chandan
