From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Mon, 16 Aug 2010 02:21:15 -0700
Message-ID: <20100816092114.GB9061@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com>
	<1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca>
	<20100812201534.GA22777@mail.oracle.com>
	<209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca>
	<20100812222949.GC22777@mail.oracle.com>
	<20100813163006.GB4329@quack.suse.cz> <4C6821A8.5080805@redhat.com>
	<20100816025436.GA9061@mail.oracle.com>
	<4C68B244.6080406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <4C68B244.6080406@redhat.com>
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

On Sun, Aug 15, 2010 at 10:36:36PM -0500, Eric Sandeen wrote:
> Er, yeah.  I had 32 bits in my head since that's the case we're
> checking for... whoops.
> 
> So I guess your
> 
>  	    ... ||
> 	    ((last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits)) >
> 	     (pgoff_t)(!0ULL))) {
> 
> is right :)  (my feeble brain has a hard time reading that, though, TBH)

	Well, note the bug in my quickly typed version: "(!0ULL)" vs
"(~0ULL)".  How about:

	u64 last_fs_page = last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits);

	... ||
	(last_fs_page > (pgoff_t)(~0ULL))) {

Is that more readable?

Joel

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
