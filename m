From: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
Date: Tue, 9 Jan 2018 10:27:50 +0100
Message-ID: <CAJKOXPfW8h4U8RKY86Sz-5BVxRQAu-ACEJtZ0hCiLVSn7tEB0Q@mail.gmail.com>
References: <20171222120556.7435-1-jlayton@kernel.org> <20171222120556.7435-20-jlayton@kernel.org>
 <CAJKOXPd8ojTjiGF3nKQKWtVrEsjWfjvg6rLL+RGnbu_SZMDu7g@mail.gmail.com>
 <1515416208.3486.14.camel@kernel.org> <CAJKOXPfv4eSERDiUuZuJ7KdpyGU0=Eqt_A+J6knp-FEW9BZoSw@mail.gmail.com>
 <1515418164.3486.18.camel@kernel.org> <20180108172928.aqndozcpljb73uj6@kozik-lap>
 <1515434419.3486.41.camel@kernel.org> <20180108183353.emiwsd4aic4gmytr@kozik-lap>
 <1515438929.3486.48.camel@kernel.org> <20180108201713.rdfjn7j65cuqmwuo@kozik-lap>
 <1515447593.3486.54.camel@kernel.org>
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
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?=
        <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515447593.3486.54.camel-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 8, 2018 at 10:39 PM, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>
>
> Got it, that's helpful. Does this patch help (on top of the others) ?
>
> ------------------------8<--------------------------
>
> SQUASH: nfs: compare raw iversion counter since that's what's
>  being stored
>

Did not apply cleanly (in include/linux/iversion.h) but it was easy to
adjust. However still no improvements. Applied on top of others.

Best regards,
Krzysztof
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
