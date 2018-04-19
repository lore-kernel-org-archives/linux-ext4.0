From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4 : fix comments in ext4_swap_extents
Date: Thu, 19 Apr 2018 12:44:56 -0400
Message-ID: <20180419164456.GI23194@thunk.org>
References: <1521448449-25916-1-git-send-email-zhenwei.pi@youruncloud.com>
 <20180419145028.44fqs4wy5ofhvn5z@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "zhenwei.pi" <zhenwei.pi@youruncloud.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419145028.44fqs4wy5ofhvn5z@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 19, 2018 at 04:50:28PM +0200, Jan Kara wrote:
> On Mon 19-03-18 16:34:09, zhenwei.pi wrote:
> > "mark_unwritten" in comment and "unwritten" in variable
> > argument lists is mismatch.
> > 
> > Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>
> 
> This seems to have fallen through cracks. The patch looks good to me. Ted,
> can you please merge it? Thanks!

It landed in 4.17-rc1, commit id: dcae058a8da9c

Cheers,

					- Ted
