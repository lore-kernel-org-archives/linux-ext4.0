From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 6/6] jbd2: remove dependency on __GFP_NOFAIL
Date: Fri, 23 Jul 2010 12:40:50 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1007231240180.5317@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1007201936210.8728@chino.kir.corp.google.com> <alpine.DEB.2.00.1007201943340.8728@chino.kir.corp.google.com> <20100722141437.GA14882@thunk.org> <alpine.DEB.2.00.1007221108360.30080@chino.kir.corp.google.com> <20100722230935.GB16373@thunk.org>
 <alpine.DEB.2.00.1007221618001.4856@chino.kir.corp.google.com> <20100723141054.GE13090@thunk.org> <20100723145730.GD3305@quack.suse.cz> <20100723150543.GG13090@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger@sun.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20100723150543.GG13090@thunk.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 23 Jul 2010, Ted Ts'o wrote:

> __GFP_NOFAIL is going away, so add our own retry loop.  Also add
> jbd2__journal_start() and jbd2__journal_restart() which take a gfp
> mask, so that file systems can optionally (re)start transaction
> handles using GFP_KERNEL.  If they do this, then they need to be
> prepared to handle receiving an PTR_ERR(-ENOMEM) error, and be ready
> to reflect that error up to userspace.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by: David Rientjes <rientjes@google.com>

Will you be pushing the equivalent patch for jbd?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
