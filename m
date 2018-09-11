From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Date: Tue, 11 Sep 2018 17:20:24 +0200
Message-ID: <20180911152024.GE6104@quack2.suse.cz>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
 <20180807084545.6gzxrtrvb34hyhdq@quack2.suse.cz>
 <8c70d61a-fc5c-b928-334a-fbb2567b8dea@sandeen.net>
 <20180911151421.GD6104@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org,
 Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180911151421.GD6104-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Tue 11-09-18 17:14:21, Jan Kara wrote:
> On Mon 10-09-18 17:18:49, Eric Sandeen wrote:
> > On 8/7/18 3:45 AM, Jan Kara wrote:
> > > 
> > > OK, this is a good catch and the patch looks good. You can add:
> > > 
> > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > > 
> > > Also please post this fix officially to Ted to include it in his tree (I
> > > can see that he has all your other patches queued for the merge window).
> > 
> > Did these ever get on Ted's radar?  I don't see it upstream yet.
> 
> Hum, it seems Ted never picked this patch up. I guess I'll gather the two
> fixes you pointed out and resend them to Ted.

Actually only one patch when looking into it now.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
