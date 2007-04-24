From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Tue, 24 Apr 2007 09:27:11 -0500
Message-ID: <462E13BF.7040703@redhat.com>
References: <462D42CA.50509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161775AbXDXOdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 10:33:23 -0400
In-Reply-To: <462D42CA.50509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avantika Mathur wrote:
> - large filesystem
>     - We would like to perform more testing on large (>16TB) filesystems
>     - currently hardware limitations are preventing this testing.  We 
> have tested 10TB raid dists, and 16TB loopback devices.  Avantika will 
> look into creating very large sparse devices for testing.

I've been hacking up some ext3@16T testing scripts to use sparse
devicemapper devices which make use of snapshots... loopback files don't
work for testing, at least not hosted on ext[234], because we still
can't do these large file offsets.

(Documentation/device-mapper/zero.txt in the kernel tree describes these
sparse dm devices)

Testing the whole range as a sparse snapshot can be slow, since
devicemapper has to do all the exception handling etc, and I think
essentially creates a fragmented block device.

I've been playing with something like this:

# 90% of the real device size is used for a "real" 1:1 mapping
# The other 10% is sparsely mapped out to add up to totalsize.
# i.e. -

#                          [large sparse-ish device]
#
# +----------------------~  ~-----------------------------------------+
# |                     sparse                |         real          |
# +----------------------~  ~-----------------------------------------+
#
# |<------------ SPARSE_SIZE ---------------->|<----- REAL_SIZE ----->|

# is mapped on top of:

#                           [real block device]
#                      +----------------------------+
#                      | sp |       real            |
#                      +----------------------------+

and then marking the sparse range as full (maybe via lazy_bg, or other
methods).  You could then also put a dm-error target under the "full"
sections so that any IO that may stray there will fail.

This way you can direct the real IO to the 1:1 mapping portion of the
large dm device, and shouldn't get the snapshot slowdowns.

Anyway, just something I've been playing with...

-eric
