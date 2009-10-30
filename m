From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Fri, 30 Oct 2009 04:16:02 -0400
Message-ID: <20091030081602.GM18464@mit.edu>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu> <20091027101534.GA27584@skywalker.linux.vnet.ibm.com> <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com> <4AEA0B71.5050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Parag Warudkar <parag.lkml@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755691AbZJ3IQR@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AEA0B71.5050805@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 29, 2009 at 04:38:57PM -0500, Eric Sandeen wrote:
>
> I've been running my testcase, and I just hit the usual corruption with  
> this patch in place after 8 iterations, I'm afraid.

Eric, since you have a relatively controllable reproduction case, have
you tried reproducing Alexey's bisection results?  Specifically he
seemed to find that commit fe188c0e shows no problem, and commit
91ac6f43 is the first commit with problems?

Having to do multiple iterations will make doing a bisection a major
pain, but maybe we'll get something out of that.

Other things that might be worth doing given that you have a test case
would be to try reverting commit 91ac6f43, and see if that helps, and
to try this patch: http://bugzilla.kernel.org/attachment.cgi?id=23468

Or have you tried some of these experiments already?

Regards,

						- Ted
