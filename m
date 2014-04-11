From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Add -s option to run only specified sections
Date: Fri, 11 Apr 2014 10:16:17 +1000
Message-ID: <20140411001617.GE15995@dastard>
References: <1397151352-6614-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1397151352-6614-1-git-send-email-lczerner@redhat.com>
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

On Thu, Apr 10, 2014 at 07:35:52PM +0200, Lukas Czerner wrote:
> This commit adds -s option which allows you to specify only certain
> sections from the config file to be run. The '-s' argument can be
> specified multiple times to allow multiple sections to be run.
> 
> The options are still carried between section, that includes the
> sections which are not going to be run.
> 
> Update README.config-sections as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Neat. Looks simple enough.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
