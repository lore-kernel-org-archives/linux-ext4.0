From: Jan Kara <jack@suse.cz>
Subject: Re: A question about function jbd2__journal_restart()
Date: Tue, 14 Apr 2015 10:43:56 +0200
Message-ID: <20150414084356.GC23327@quack.suse.cz>
References: <552C82B9.7060305@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
To: Xue jiufei <xuejiufei@huawei.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <552C82B9.7060305@huawei.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Tue 14-04-15 11:00:09, Xue jiufei wrote:
> I have a question about function jbd2__journal_restart().
> If we call this function when there's not more credits,
> it may commit the handle's transaction and start another one.
> So a handle can be attached to 2 transaction and can not ensure the
> consistency. It is the caller's responsibility to keep things consistently
> before call jbd2__journal_restart(), right?
  Correct.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
