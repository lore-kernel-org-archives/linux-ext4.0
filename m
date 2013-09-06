From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3, reiserfs, udf & isofs fixes
Date: Fri, 6 Sep 2013 09:11:18 -0700
Message-ID: <CA+55aFytAMNADORn4FfUO620OvLdiMRNVhYbVuCFnWgo4kpvjQ@mail.gmail.com>
References: <20130905195802.GA9260@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130905195802.GA9260@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 5, 2013 at 12:58 PM, Jan Kara <jack@suse.cz> wrote:
>
> udf/isofs changes to refuse mounting fs rw instead of mounting it
> ro automatically which makes eject button work as expected for all media (see
> the changelog for why userspace should be ok with this change).

Pulled. However, these are kind of odd.

For trying _remount_ something read-only, isofs returns the logical
EROFS error code.

But for trying to mount it in the first place, it returns EACCES,
which sounds insane. It's not a permission problem - no amount of
permissions will ever make it work.

UDF always does EACCES, regardless of mount/remount.

Is there some fundamental reason for the insane error code? Does user
space do the wrong thing if we were to just always return "EROFS"
which makes much more sense?

                 Linus
