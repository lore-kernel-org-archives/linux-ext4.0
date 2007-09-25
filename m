From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 11:14:00 +0200
Message-ID: <20070925091400.GA2806@petra.dvoda.cz>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	List util-linux-ng <util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070924124035.GA4209-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 24, 2007 at 08:40:36AM -0400, Theodore Tso wrote:
> On Mon, Sep 24, 2007 at 11:25:39AM +0200, Karel Zak wrote:
> > > 
> > > Nope, there isn't much rationale unless we also split out fsck, so
> > 
> >  util-linux-ng is open for fsck :-)
> 
> It's something I'm considering, but at the moment I've got some higher
> priority (ext4) work that I'm focusing on.  

 That's nothing urgent. This migration shouldn't be so difficult -- I
 think we should provide at least one release when the util is in both
 packages -- defaultly disabled in e2fsprogs and enabled in
 util-linux-ng. It's probably better that trying to synchronize
 releases of both packages.

> What would you think about moving libblkid and the libdisk from
> xfsprogs into util-linux-ng?  That's things that I've been batting

 I have no problem with this idea, but I'd like to invite Kay Sievers
 (udev) to this discussion. I think the best step will be merge
 libblkid and libvolume_id to the one independent project. There is
 few technical problems with this idea, but nothing insolvable.

 Now we duplicate a lot of FS probe code in libblkid, libvolume_id and
 libdisk.

 Yes, it's long-term task, but it's good direction (IMHO).

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
