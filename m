From: "Yan, Zheng" <zyan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] fs/*/Kconfig: drop links to 404-compliant
 http://acl.bestbits.at
Date: Thu, 14 Dec 2017 14:34:27 +0800
Message-ID: <7C5A4F68-5893-4EC7-99D6-8235C8DA1381@redhat.com>
References: <20171213053825.10903-1-kilobyte@angband.pl>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
        linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
        Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
        Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
        Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Sage Weil <sage-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        ceph-devel <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
To: Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171213053825.10903-1-kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org



> On 13 Dec 2017, at 13:38, Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org> wrote:
> 
> This link is replicated in most filesystems' config stanzas.  Referring
> to an archived version of that site is pointless as it mostly deals with
> patches; user documentation is available elsewhere.
> 
> Signed-off-by: Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
> ---
> Sending this as one piece; if you guys would instead prefer this chopped
> into tiny per-filesystem bits, please say so.
> 
> 
> Documentation/filesystems/ext2.txt |  2 --
> Documentation/filesystems/ext4.txt |  7 +++----
> fs/9p/Kconfig                      |  3 ---
> fs/Kconfig                         |  6 +-----
> fs/btrfs/Kconfig                   |  3 ---
> fs/ceph/Kconfig                    |  3 —

Ceph bits looks good.

Acked-by:  Yan, Zheng" <zyan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
