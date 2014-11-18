From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/11] quota: Split ->set_xstate callback into two
Date: Tue, 18 Nov 2014 17:05:09 +0100
Message-ID: <20141118160509.GA29472@quack.suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-5-git-send-email-jack@suse.cz>
	<20141113173416.GA31481@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20141113173416.GA31481@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Thu 13-11-14 09:34:16, Christoph Hellwig wrote:
> On Tue, Nov 11, 2014 at 10:04:18PM +0100, Jan Kara wrote:
> > Split ->set_xstate callback into two callbacks - one for turning quotas
> > on (->sysquota_on) and one for turning quotas off (->sysquota_off). That
> > way we don't have to pass quotactl command into the callback which seems
> > cleaner.
> 
> Yes, I much prefer these to be split.  But the names seem a little odd,
> why not enable_quota/disable_quota?
  I wanted to clearly separate this from quota_on() / quota_off() callbacks
which are for userspace visible quota files. However enable_quota /
disable_quota sound fine as well.
 
> > +static unsigned int generic_to_xfs_flags(unsigned int uflags)
> 
> xfs_quota_flags() ?
  OK.

								Honza
  
 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
