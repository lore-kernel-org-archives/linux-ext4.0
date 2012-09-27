From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfstest: add configurable load factors
Date: Thu, 27 Sep 2012 10:06:38 +1000
Message-ID: <20120927000638.GC15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
 <1348496601-32637-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@lst.de, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348496601-32637-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 24, 2012 at 06:23:17PM +0400, Dmitry Monakhov wrote:
> Most stress test has probable behaviour, the longer test run the
> larger corner cases will be cover. It is reasonable to allow
> user to provide some sort of system load factor.
> This patch introduce two global variables
> LOAD_FACTOR: Usually means factor number of running tasks
> TIME_FACTOR: Usually means factor of run time, or number of operations
> If not speficied both variables defined to 1, so original behaviour
> preserved.
> 
> TODO: Change all stress tests to use this variables
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  common.config |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/common.config b/common.config
> index d5c8956..cfa7bde 100644
> --- a/common.config
> +++ b/common.config
> @@ -253,5 +253,13 @@ if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
>      exit 1
>  fi
>  
> +if [ -z "$LOAD_FACTOR" ]; then
> +    LOAD_FACTOR=1
> +fi
> +
> +if [ -z "$TIME_FACTOR" ]; then
> +    TIME_FACTOR=1
> +fi

They probably need to be exparted variables set up through the
check script, not somthing sourced via common.config. i.e. something
like this in check where the environment is being set up:

export TIME_FACTOR=${TIME_FACTOR:=1}
export LOAD_FACTOR=${LOAD_FACTOR:=1}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
