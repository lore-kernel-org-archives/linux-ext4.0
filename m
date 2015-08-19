From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC -v2 7/8] btrfs: Prevent from early transaction abort
Date: Wed, 19 Aug 2015 14:26:40 +0200
Message-ID: <20150819122640.GA8541@dhcp22.suse.cz>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-8-git-send-email-mhocko@kernel.org>
 <20150818104031.GF5033@dhcp22.suse.cz>
 <20150818171144.GA5206@ret.DHCP.TheFacebook.com>
 <20150818172914.GO5033@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Chris Mason <clm@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150818172914.GO5033@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 18-08-15 19:29:14, Michal Hocko wrote:
> On Tue 18-08-15 13:11:44, Chris Mason wrote:
> > On Tue, Aug 18, 2015 at 12:40:32PM +0200, Michal Hocko wrote:
> > > From: Michal Hocko <mhocko@suse.com>
> > > 
> > > Btrfs relies on GFP_NOFS allocation when commiting the transaction but
> > > since "mm: page_alloc: do not lock up GFP_NOFS allocations upon OOM"
> > > those allocations are allowed to fail which can lead to a pre-mature
> > > transaction abort:
> > 
> > I can either put the btrfs nofail ones on my pull for Linus, or you can
> > add my sob and send as one unit.  Just let me know how you'd rather do
> > it.
> 
> OK, I will rephrase the changelogs (tomorrow) to not refer to an
> unmerged patch and would appreciate if you can take them and route them
> through your tree. I will then drop them from my pile.

Poste in a separate thread
http://lkml.kernel.org/r/1439986661-15896-1-git-send-email-mhocko@kernel.org
-- 
Michal Hocko
SUSE Labs
