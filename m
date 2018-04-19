From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4 : fix comments in ext4_swap_extents
Date: Thu, 19 Apr 2018 22:13:10 +0200
Message-ID: <20180419201310.hjxzigbdt4uyjdkz@quack2.suse.cz>
References: <1521448449-25916-1-git-send-email-zhenwei.pi@youruncloud.com>
 <20180419145028.44fqs4wy5ofhvn5z@quack2.suse.cz>
 <20180419164456.GI23194@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, "zhenwei.pi" <zhenwei.pi@youruncloud.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419164456.GI23194@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 19-04-18 12:44:56, Theodore Y. Ts'o wrote:
> On Thu, Apr 19, 2018 at 04:50:28PM +0200, Jan Kara wrote:
> > On Mon 19-03-18 16:34:09, zhenwei.pi wrote:
> > > "mark_unwritten" in comment and "unwritten" in variable
> > > argument lists is mismatch.
> > > 
> > > Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>
> > 
> > This seems to have fallen through cracks. The patch looks good to me. Ted,
> > can you please merge it? Thanks!
> 
> It landed in 4.17-rc1, commit id: dcae058a8da9c

Ah, somehow I missed that. Sorry.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
