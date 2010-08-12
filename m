From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Thu, 12 Aug 2010 16:03:31 -0700
Message-ID: <20100812230331.GD22777@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        "linux-kernel@vger.ker
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20100812174215.GC6561@mail.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 12, 2010 at 10:42:16AM -0700, Joel Becker wrote:
> On Thu, Jul 22, 2010 at 03:03:41PM -0700, Patrick J. LoPresti wrote:
> > As part of adding support for OCFS2 to mount huge volumes, we need to
> > check that the sector_t and page cache of the system are capable of
> > addressing the entire volume.
> > 
> > An identical check already appears in ext3 and ext4.  This patch moves
> > the addressability check into its own function in fs/libfs.c and
> > modifies ext3 and ext4 to invoke it.
> > 
> > Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> 
> Dear ext3/4 folks,
> 	I've pushed this patch to the merge-window branch of ocfs2.git.
> I'm ready to send it to Linus, But I need your OK.

	To be specific, I would like an Acked-by.

Joel

-- 

Life's Little Instruction Book #456

	"Send your loved one flowers.  Think of a reason later."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
