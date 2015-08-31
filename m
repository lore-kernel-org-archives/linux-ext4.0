From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Mon, 31 Aug 2015 14:37:38 -0700
Message-ID: <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
References: <20150831061920.GA2751@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150831061920.GA2751@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 30, 2015 at 11:19 PM, Jan Kara <jack@suse.cz> wrote:
>
> The biggest change in the pull is the removal of ext3 filesystem driver
> (~28k lines removed).

I really am not ready to just remove ext3 without a lot of good
arguments. There might well be people who this use ext3 as ext3, and
don't want to update. I want more a rationale for removal than "ext4
can read old ext3 filesystems".

                  Linus
