From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_count_free_clusters() with EXT4FS_DEBUG
 and bigalloc enabled
Date: Mon, 14 Apr 2014 23:37:38 -0400
Message-ID: <20140415033738.GB3403@thunk.org>
References: <1397492316-12237-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	open list <linux-kernel@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397492316-12237-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 14, 2014 at 08:18:36PM +0400, Azat Khuzhin wrote:
> With bigalloc enabled we must use EXT4_CLUSTERS_PER_GROUP() instead of
> EXT4_BLOCKS_PER_GROUP() otherwise we will go beyond the allocated buffer.

You forgot the signed-off-by, since it's a one-line patch, I'll apply it.  Thanks!

    	       		      	    	   - Ted
