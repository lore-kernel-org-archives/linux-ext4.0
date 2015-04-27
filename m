From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] shared/289: do not special-case ext3
Date: Mon, 27 Apr 2015 23:44:51 +0800
Message-ID: <20150427154451.GE17534@dhcp-13-216.nay.redhat.com>
References: <1430134449-16060-1-git-send-email-eguan@redhat.com>
 <553E534B.5000805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: sandeen@redhat.com
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <553E534B.5000805@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 27, 2015 at 10:18:35AM -0500, Eric Sandeen wrote:
> On 4/27/15 6:34 AM, Eryu Guan wrote:
> > Commit "3574531 xfstests: count journal size in test 289" makes ext3 a
> > special case, but now it's not the case anymore after kernel commit
> > 
> > e6d8fb3 ext3: Count internal journal as bsddf overhead in ext3_statfs
> > 
> > So just remove the special case, now test passes on both ext3 and ext4,
> > also ext3 driven by ext4 module.
> 
> I think perhaps it was actually:
> 
> 2046fd1 ext3: Count journal as bsddf overhead in ext3_statfs
> 
> (in v3.13) which changed the behavior; the commit you mention only
> removes the overhead again for external journals, but your change
> below looks fine.

You're right, I pasted the wrong commit, I meant 2046fd1, will send v2.

> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks for the review!

Eryu
> 
> 
> .> Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  tests/shared/289 | 13 +------------
> >  1 file changed, 1 insertion(+), 12 deletions(-)
> > 
> > diff --git a/tests/shared/289 b/tests/shared/289
> > index c53d38c..96c949d 100755
> > --- a/tests/shared/289
> > +++ b/tests/shared/289
> > @@ -58,18 +58,7 @@ TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> >  FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> >  		| awk '/Free blocks:/{print $3}'`
> >  
> > -# ext3 doesn't count journal blocks as overhead, ext4 does.
> > -if [ $FSTYP = "ext3" ]; then
> > -	JOURNAL_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> > -		| awk '/Journal size:/{print $3}' | _filter_size_to_bytes`
> > -	BLOCK_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> > -		| awk '/Block size:/{print $3}'`
> > -	JOURNAL_BLOCKS=$(($JOURNAL_SIZE/$BLOCK_SIZE))
> > -else
> > -	JOURNAL_BLOCKS=0
> > -fi
> > -
> > -OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS-$JOURNAL_BLOCKS))
> > +OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
> >  
> >  #  bsddf|minixdf
> >  #         Set the behaviour  for  the  statfs  system  call.  The  minixdf
> > 
> 
