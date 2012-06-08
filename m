From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC, PATCH, RESEND] fs: push rcu_barrier() from
 deactivate_locked_super() to filesystems
Date: Fri, 8 Jun 2012 15:27:28 -0700
Message-ID: <CA+55aFw1yLOYzVCWMRUERNPEKgnrOfGNGmU335H_4aqGPLwq0Q@mail.gmail.com>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120608150253.e42464a6.akpm@linux-foundation.org> <20120608221446.GA18250@otc-wbsnb-06>
 <20120608222337.GR30000@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Tao Ma <boyu.mt@taobao.com>, Nick Piggin <npiggin@kernel.dk>,
	"Dmitry V. Levin" <ldv@altlinux.org>,
	v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	osd-dev@open-osd.org, linux-ext4@vger.kernel.org,
	fuse-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net, logfs@logfs.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120608222337.GR30000@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 8, 2012 at 3:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Note that module unload is *not* a hot path - not on any even remotely sane
> use.

Actually, I think we've had distributions that basically did a "load
pretty much everything, and let God sort it out" approach to modules.
I know some people *have* actually worried about module load/unload
performance.

Whether it is "remotely sane" I'm not going to argue for, but ..

                Linus
