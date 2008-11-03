From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] improve jbd fsync batching
Date: Mon, 3 Nov 2008 12:55:09 -0800
Message-ID: <20081103125509.41e55529.akpm@linux-foundation.org>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
	<20081103122729.60582692.akpm@linux-foundation.org>
	<20081103202442.GA25736@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jbacik@redhat.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081103202442.GA25736@unused.rdu.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 3 Nov 2008 15:24:43 -0500
Josef Bacik <jbacik@redhat.com> wrote:

> > please fix.
> 
> I see you already pulled this into -mm, would you like me to repost with the
> same changelog and the patch updated, or just reply to this with the updated
> patch?  Thanks,

Either works for me at this stage.  If it's a replacement then I'll turn
it into an incremental so I can see what changed, which takes me about 2.15
seconds.

If it had been a large patch or if it had been under test in someone's
tree for a while then a replacement patch would be unwelcome.  But for a
small, fresh patch like this one it's no big deal either way.

