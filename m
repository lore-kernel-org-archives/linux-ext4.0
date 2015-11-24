From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 00/12] Enhanced file stat system call
Date: Tue, 24 Nov 2015 00:50:25 -0800
Message-ID: <20151124085025.GA22398@infradead.org>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <1502878.QisWlqATFu@merkaba>
 <20151124081308.GB8840@infradead.org>
 <51731897.vGpjiNuy9t@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	David Howells <dhowells@redhat.com>, arnd@arndb.de,
	linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51731897.vGpjiNuy9t@merkaba>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 24, 2015 at 09:48:22AM +0100, Martin Steigerwald wrote:
> It might be interesting for BTRFS as well, to be able to ask what amount of 
> free space there currently is *at* a given path. Cause with BTRFS and 
> Subvolumes this may differ between different paths.

We can handle this trivial with the current statfs interface.  Take a
look at xfs_fs_statfs and xfs_qm_statvfs.
