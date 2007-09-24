From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Mon, 24 Sep 2007 08:16:41 -0500
Message-ID: <46F7B8B9.4040707@redhat.com>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	List util-linux-ng <util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20070924124035.GA4209-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Mon, Sep 24, 2007 at 11:25:39AM +0200, Karel Zak wrote:
>>> Nope, there isn't much rationale unless we also split out fsck, so
>>  util-linux-ng is open for fsck :-)
> 
> It's something I'm considering, but at the moment I've got some higher
> priority (ext4) work that I'm focusing on.  
> 
> What would you think about moving libblkid and the libdisk from
> xfsprogs into util-linux-ng?  That's things that I've been batting
> around doing, although that means we end up moving more libraries that
> distros would probably want separated into different packages into
> util-linux-ng....

Heh, sounds a little like a prisoner exchange... "we'll give up libblkid
& libcom_err if you give up libdisk" :)

Seriously, though, that all sounds like a pretty good idea to me,
especially since e2fsprogs has been making noise about utilizing some of
the functionality in xfsprogs (stripe discovery etc).

-Eric
