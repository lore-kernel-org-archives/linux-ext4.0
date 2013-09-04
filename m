From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
Date: Wed, 4 Sep 2013 17:08:54 +0200
Message-ID: <20130904150854.GF3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
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

On Thu 22-08-13 17:03:16, Andy Lutomirski wrote:
> Writes via mmap currently update mtime and ctime in ->page_mkwrite.
> This hurts both throughput and latency.  In workloads that dirty a
> large number of mmapped pages, ->page_mkwrite can be hot and
> file_update_time is slow and scales poorly.  Updating timestamps can
> also sleep, which hurts latency for real-time workloads.
  It would help to make your case if you posted the latency comparison
before & after the patchset in this introductory email. We can then see
how significant is the reduction of latency...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
