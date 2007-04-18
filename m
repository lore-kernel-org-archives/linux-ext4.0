From: Bruno Wolff III <bruno@wolff.to>
Subject: Re: Ext3 behavior on power failure
Date: Wed, 18 Apr 2007 16:49:04 -0500
Message-ID: <20070418214904.GA10541@wolff.to>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com>
	<4603B03E.7080302@emc.com>
	<20070328124015.GG14935@atrey.karlin.mff.cuni.cz>
	<alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: csar@stanford.edu, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, ext3-users@redhat.com,
	Ric Wheeler <ric@emc.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <ext3-users-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0703280915400.30460@sigma.j-a-k-j.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 28, 2007 at 09:17:27 -0400,
  "John Anthony Kazos Jr." <jakj@j-a-k-j.com> wrote:
> > If you fsync() your data, you are guaranteed that also your data are
> >safely on disk when fsync returns. So what is the question here?
> 
> Pardon a newbie's intrusion, but I do know this isn't true. There is a 
> window of possible loss because of the multitude of layers of caching, 
> especially within the drive itself. Unless there is a super_duper_fsync() 
> that is able to actually poll the hardware and get a confirmation that the 
> internal buffers are purged?

That is why you need to disable write caching of the drives or use cache
flushes via write barriers (if the stack of block devices all support them)
if the hardware cache isn't battery backed or the device doesn't support
returning the status of particular commands.

Of course nothing is perfectly safe.
