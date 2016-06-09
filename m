From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/21] fs: ext4: Use current_fs_time() for inode timestamps
Date: Thu, 9 Jun 2016 11:55:24 -0700
Message-ID: <CA+55aFzc0DC8bHkd4GKVwiwhJfTmPnfHZhkUJT2ovb=nh-T0Eg@mail.gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-3-git-send-email-deepa.kernel@gmail.com> <CA+55aFx7ES7D_9uVL3T1htJj6onQP2Z2TrDqTG+Qd9AuHnVf-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Al Viro <viro@zeniv.linux.org.uk>, y2038@lists.linaro.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx7ES7D_9uVL3T1htJj6onQP2Z2TrDqTG+Qd9AuHnVf-g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 9, 2016 at 11:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> All existing users and all the ones in this patch (and the others too,
> although I didn't go through them very carefully) really would prefer
> just passing in the inode directly, rather than the superblock.

Actually, there seems to be one exception to that "all existing
users", and that one exception (btrfs transacation time) really seems
to be broken. Exactly because it's *not* setting an inode time, it
shouldn't have used current_fs_time() to begin with, because it is
just setting an internal filesystem timestamp.

So not making the argument inode-related seems to actually encourage
people to misuse this function.

                Linus
