From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Mon, 24 Sep 2007 08:40:36 -0400
Message-ID: <20070924124035.GA4209@thunk.org>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	List util-linux-ng <util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070924092539.GC2819-CxBs/XhZ2BtHjqfyn1fVYA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 24, 2007 at 11:25:39AM +0200, Karel Zak wrote:
> > 
> > Nope, there isn't much rationale unless we also split out fsck, so
> 
>  util-linux-ng is open for fsck :-)

It's something I'm considering, but at the moment I've got some higher
priority (ext4) work that I'm focusing on.  

What would you think about moving libblkid and the libdisk from
xfsprogs into util-linux-ng?  That's things that I've been batting
around doing, although that means we end up moving more libraries that
distros would probably want separated into different packages into
util-linux-ng....

						- Ted
