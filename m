From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 05/10] xfstest: allow fsstress to use load factor where
	appropriate
Date: Fri, 1 Mar 2013 09:43:54 -0600
Message-ID: <5130CCBA.4000307@sgi.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	dchinner@redhat.com, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1361356935-29153-6-git-send-email-dmonakhov@openvz.org>
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

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> 1) Add _scale_fsstress_args function which transform argumets according
>     to load factors
> 2) Let all non deterministic fsstress tests to use scaled arguments
>
> I've able to trigger OOPS on xfs see:https://gist.github.com/dmonakhov/4762653
>

I did not see any OOPS.  Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
