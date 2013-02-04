From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
 non page aligned ranges
Date: Mon, 4 Feb 2013 12:51:36 -0800
Message-ID: <20130204125136.b0926f20.akpm@linux-foundation.org>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
	<1359715424-32318-11-git-send-email-lczerner@redhat.com>
	<20130201151502.59398b29.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1302041510090.3225@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
 Hugh Dickins <hughd@google.com>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Czerner <lczerner@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LFD.2.00.1302041510090.3225@localhost>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 4 Feb 2013 15:51:19 +0100 (CET)
Luk____ Czerner <lczerner@redhat.com> wrote:

> I hope I explained myself well enough :). Are you ok with this king
> of approach ? If so, I'll resend the patch set without the
> initialisation-at-declaration.

uh, maybe.  Next time I'll apply the patch and look at the end result! 
Try to make it as understandable and (hence) maintainable as possible,
OK?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
