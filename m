From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] inode->i_version rework for v4.16
Date: Tue, 30 Jan 2018 08:36:56 -0800
Message-ID: <CA+55aFwD-=YNXQTOSNZE9SQwsin=ay56GOt4gekYe1U0qPeksQ@mail.gmail.com>
References: <1517228795.5965.24.camel@redhat.com> <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
 <1517313948.3658.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
        xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-integrity <linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517313948.3658.8.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 30, 2018 at 4:05 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> My intent here was to have this handle wraparound using the same sort of
> method that the time_before/time_after macros do. Obviously, I didn't
> document that well.

Oh, the intent was clear. The implementation was wrong.

Note that "time_before()" returns a _boolean_.

So yes, the time comparison functions do a 64-bit subtraction, exactly
like yours do. BUT THEY DO NOT RETURN THAT DIFFERENCE. They test the
sign in 64 bits and return that boolean single-bit value.

> I want to make sure I understand what's actually broken here thoug. Is
> it only broken when the two values are more than 2**63 apart, or is
> there something else more fundamentally wrong here?

There's something fundamentally wrong. The _intent_ is to allow
numbers up to 2**63 apart, but if somebody does that

     int cmp = inode_cmp_iversion(inode, old);

     if (cmp < 0 ...

then it actually only ever tests numbers 2**31 apart, because the high
32 bits will have been thrown away when the 64-bit difference is cast
to "int".

And what used to be a sign bit (in 64 bits) no longer exists, and the
above tests the *new* sign bit that is bit #31, not #63.

So you are a factor of four billion off.

And while 2**63 is a big number and perfectly ok for a filesystem
event difference, a difference of 2**31 is a "this can actually
happen".

Yes, even 2**31 is still a big difference, and it will take a very
unusual situation, and quite a long time to trigger: something that
does a thousand filesystem ops per second will not see the problem for
24 days. So you'll never see it in a test. But 24 days happens in real
life..

That's why you need to do the comparison against zero inside the
actual helper functions like the time comparisons do. Because if you
return the 64-bit difference, it will be trivially lost, and the code
will _look_ right, but not work right.

The fact that you didn't even seem to see the problem in my example
calling sequence just proves that point.

                   Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
