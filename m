From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH 1/1] XFS TESTS: Correct extent flag parsing for punch
 hole tests
Date: Fri, 15 Jul 2011 08:46:54 -0500
Message-ID: <1310737614.2921.4.camel@doink>
References: <1310701933-18988-1-git-send-email-achender@linux.vnet.ibm.com>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<xfs@oss.sgi.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1310701933-18988-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2011-07-14 at 20:52 -0700, Allison Henderson wrote:
> The fiemap filters used in the punch hole tests parse the
> extent flags in the fiemap to determine the extent type.
> They are currently parsing them as decimal values, but
> they should be parsing hex values.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

Looks good to me.  This may not have a practical
effect but it looks correct now.

I will commit this for you.  Thanks for fixing it.

Reviewed-by: Alex Elder <aelder@sgi.com>


