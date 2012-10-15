From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v3 12/13] vfs: add debugfs support
Date: Mon, 15 Oct 2012 18:55:30 +1100
Message-ID: <20121015075530.GZ2739@dastard>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 10, 2012 at 06:07:34PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
> volume that contains two files. The first, `inode_data', contains the
> heat information for inodes that have been brought into the hot data map
> structures. The second, `range_data', contains similar information for
> subfile ranges.
....
> +	/* create debugfs range_data file */
> +	debugfs_range_entry = debugfs_create_file("range_data",
> +				S_IFREG | S_IRUSR | S_IWUSR | S_IRUGO,
> +				debugfs_volume_entry,
> +				(void *) range_data,
> +				&hot_debugfs_range_fops);

These should not be world readable. 0600 is probably the correct
permissions for them as we do not want random users to be able to
infer what files users are accessing from this information.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
