From: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 19/19] fs: handle inode->i_version more efficiently
Date: Wed, 10 Jan 2018 15:12:42 +0100
Message-ID: <CAJKOXPckGaNF0HTqLMzxJKg_r4r7HZy9GFoOUs_vxeZfa_kb=A@mail.gmail.com>
References: <20180109141059.25929-1-jlayton@kernel.org> <20180109141059.25929-20-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, jack-l3A5Bk7waGM@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109141059.25929-20-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 9, 2018 at 3:10 PM, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Since i_version is mostly treated as an opaque value, we can exploit that
> fact to avoid incrementing it when no one is watching. With that change,
> we can avoid incrementing the counter on writes, unless someone has
> queried for it since it was last incremented. If the a/c/mtime don't
> change, and the i_version hasn't changed, then there's no need to dirty
> the inode metadata on a write.
>
> Convert the i_version counter to an atomic64_t, and use the lowest order
> bit to hold a flag that will tell whether anyone has queried the value
> since it was last incremented.
>
> When we go to maybe increment it, we fetch the value and check the flag
> bit.  If it's clear then we don't need to do anything if the update
> isn't being forced.
>
> If we do need to update, then we increment the counter by 2, and clear
> the flag bit, and then use a CAS op to swap it into place. If that
> works, we return true. If it doesn't then do it again with the value
> that we fetch from the CAS operation.
>
> On the query side, if the flag is already set, then we just shift the
> value down by 1 bit and return it. Otherwise, we set the flag in our
> on-stack value and again use cmpxchg to swap it into place if it hasn't
> changed. If it has, then we use the value from the cmpxchg as the new
> "old" value and try again.
>
> This method allows us to avoid incrementing the counter on writes (and
> dirtying the metadata) under typical workloads. We only need to increment
> if it has been queried since it was last changed.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  include/linux/fs.h       |   2 +-
>  include/linux/iversion.h | 210 ++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 155 insertions(+), 57 deletions(-)

Works fine on my nfsroot configuration so looks like the issues from
v4 are gone. FWIW:
Tested-by: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Best regards,
Krzysztof
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
