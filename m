From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
Date: Wed, 03 Apr 2013 11:51:34 +0400
Message-ID: <87obdwqcft.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <874nfps133.fsf@openvz.org> <876098945.1097253.1364961617725.JavaMail.root@redhat.com> <1158933859.1177381.1364973284305.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>, stable@vger.kernel.org
To: CAI Qian <caiqian@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1158933859.1177381.1364973284305.JavaMail.root@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 3 Apr 2013 03:14:44 -0400 (EDT), CAI Qian <caiqian@redhat.com> wrote:
> 
> > > [Text Documents:disable-es_lookup_extent.patch]
> With this patch, I cannot reproduce it any more.
Ok that is second confirmation that bug caused by issue in es_cache,
This is not a fix though. So still try to investigate that.
> 
> CAI Qian
