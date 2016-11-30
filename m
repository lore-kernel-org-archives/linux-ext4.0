From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Date: Wed, 30 Nov 2016 10:59:44 -0500
Message-ID: <20161130155944.GA12630@cmpxchg.org>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
 <1479980796-26161-3-git-send-email-jack@suse.cz>
 <20161129193403.GA12396@cmpxchg.org>
 <20161130080841.GD16667@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161130080841.GD16667-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Wed, Nov 30, 2016 at 09:08:41AM +0100, Jan Kara wrote:
> > The naming situation with truncate, invalidate, invalidate2 worries me
> > a bit. They aren't great names to begin with, but now DAX uses yet
> > another terminology for what state prevents a page from being dropped.
> > Can we switch to truncate, invalidate, and invalidate_sync throughout
> > truncate.c and then have DAX follow that naming too? Or maybe you can
> > think of better names. But neither invalidate2 and invalidate_clean
> > don't seem to capture it quite right ;)
> 
> Yeah, the naming is confusing. I like the invalidate_sync proposal however
> renaming invalidate_inode_pages2() to invalidate_inode_pages_sync() is a
> larger undertaking - grep shows 51 places need to be changed. So I don't
> want to do it in this patch set. I can call the function
> dax_invalidate_mapping_entry_sync() if it makes you happier and do the rest
> later... OK?

Yep, that sounds reasonable on both counts.
