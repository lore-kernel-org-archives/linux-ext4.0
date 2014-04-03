From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Date: Thu, 3 Apr 2014 15:30:40 -0400
Message-ID: <20140403193039.GD32323@thunk.org>
References: <20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
	<alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
	<CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
	<20140403173504.GB23737@thunk.org> <533DB140.8010103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
	lsf@lists.linux-foundation.org, Sedat Dilek <sedat.dilek@gmail.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <533DB140.8010103@redhat.com>
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

On Thu, Apr 03, 2014 at 01:06:40PM -0600, Eric Sandeen wrote:
> On 4/3/14, 11:35 AM, Theodore Ts'o wrote:
> 
> >>  - There's an undocumented way to write results outside the source
> >> tree called RESULT_BASE.  It would be great if it were documented and
> >> spelled consistently.
> 
> I'm not actually certain that it was intended to be used this way.
> See 1686f9ab "xfstests: Introduce a results directory" 
> which explains just where this variable came from and what it's
> for...

The last paragraph states of the git description states:

    This is the first (small) step in being able to store test results
    in an external location for archival/data mining purposes.

The question I suppose is whether storing the results in an external
location is something that should be xfstests' responsibility, or of
the test harnesses that call xfstests.  I suspect that since there are
so many different ways people might want to archive the results, it
does make sense for the test harnesses to handle this job, but I
wouldn't want to "presume" on anything that the xfstests developers
might choose to do....

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
