From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] Remove two unneeded exports and make two symbols
	static in fs/mpage.c
Date: Wed, 1 Apr 2009 12:39:34 +0100
Message-ID: <20090401113934.GB28946@ZenIV.linux.org.uk>
References: <1238449280-10318-1-git-send-email-dmitri.vorobiev@movial.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	alex@clusterfs.com, aneesh.kumar@linux.vnet.ibm.com
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1238449280-10318-1-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 31, 2009 at 12:41:20AM +0300, Dmitri Vorobiev wrote:
> Commit 29a814d2ee0e43c2980f33f91c1311ec06c0aa35 (vfs: add hooks for
> ext4's delayed allocation support) exported the following functions
> 
> mpage_bio_submit()
> __mpage_writepage()
> 
> for the benefit of ext4's delayed allocation support. Since commit
> a1d6cc563bfdf1bf2829d3e6ce4d8b774251796b (ext4: Rework the
> ext4_da_writepages() function), these functions are not used by the
> ext4 driver anymore. However, the now unnecessary exports still
> remain, and this patch removes those. Moreover, these two functions
> can become static again.
> 
> The issue was spotted by namespacecheck.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>

Applied.
