From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/12] generic/80[0-2]: support xfs in addition to btrfs
Date: Thu, 15 Oct 2015 07:41:46 -0700
Message-ID: <20151015144146.GL10391@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
	<20151007051323.3260.60421.stgit@birch.djwong.org>
	<20151015091944.GA13683@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20151015091944.GA13683@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 15, 2015 at 02:19:44AM -0700, Christoph Hellwig wrote:
> > +# this test requires the test fs support reflink...
> > +#
> > +_require_test_reflink()
> > +{
> > +    case $FSTYP in
> > +    xfs)
> > +	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +	;;
> > +    btrfs)
> > +        true
> > +        ;;
> > +    *)
> > +        _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +        ;;
> > +    esac
> 
> I don't think that's a good test - we need to check if it's supported by
> trying it.  That'll automatically get us coverage for other file systems
> like xfs.
> 
> Note that dedup should get it's own feature check, as currently hacking
> nfs into this check will also run dedup tests that can't really be
> supported.

Good point.  I'll throw that in while I rework the tests.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
