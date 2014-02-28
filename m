From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 5/8] xfstests: Add fallocate zero range operation to
	fsstress
Date: Fri, 28 Feb 2014 11:40:08 -0600
Message-ID: <5310C9F8.20009@sandeen.net>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<1393603865-26198-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1393603865-26198-5-git-send-email-lczerner@redhat.com>
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

On 2/28/14, 10:11 AM, Lukas Czerner wrote:
> This commit adds fzero operation support for fsstress, which is meant to
> exercise fallocate FALLOC_FL_ZERO_RANGE support.
> 
> Also reorganise the common fallocate code into a single do_fallocate()
> function and use flags use the right mode.
> 
> Also in order to make more obvious which fallocate mode fsstress is
> testing translate fallocate flags into human readable strings.

Can you enhance that so that if it's passed a flag which isn't
in the known array, it prints the leftover values?  Otherwise
they are silently dropped, which might be confusing.

Handling the case where a flag is not in the array would future-proof
it, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
