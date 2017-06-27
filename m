From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Possible regression in e2fsprogs-1.43.4  [RESOLVED]
Date: Mon, 26 Jun 2017 21:53:38 -0400
Message-ID: <20170627015338.5heipzrsmp4dwsmd@thunk.org>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
	<20170623195318.cfs4ftpmy5nhcccy@thunk.org>
	<20170623232935.13fa4688@leda>
	<048DD704-9937-4E2F-9BBD-2430CB734E2D@illumenos.com>
	<F43FD2C9-608B-4D5E-A61A-749993688E61@illumenos.com>
	<20170626024019.hni2k6uwfb7sknaw@thunk.org>
	<53DF6A08-AA60-4A9C-BD29-46475DAB528A@illumenos.com>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
	Christian Hesse <list@eworm.de>, linux-ext4@vger.kernel.org
To: Felipe A Rodriguez <far@illumenos.com>
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
Content-Disposition: inline
In-Reply-To: <53DF6A08-AA60-4A9C-BD29-46475DAB528A@illumenos.com>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel/>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Sender: "Grub-devel" <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 26, 2017 at 08:46:48AM +0200, Felipe A Rodriguez wrote:
> > So when you say that enabling the 64-bit file system feature causes a
> > regression by causing Grub to fail to be able to read the root file
> > system, I have to respectfully disagree.  I do it all the time when I
> > reboot my kernel, and it Works For Me...
> 
> Huh ???  I indicated GRUB 2.00 stopped working with the upgrade to 1.43.4, but GRUB 2.02 works fine.

You originally said:

On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
> Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot
> loader to fail (unknown filesystem error) on the x86_64 VM I use for
> initial testing.  I traced the problem to changes in the e2fsprogs
> configuration file which now sets 64 bit flags.  I tried upgrading
> to GRUB 2.02 but that did not resolve the problem.
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In your follow up, you didn't bother line wrapping your message, so I
misparsed the sentence where you stated "Grub 2.02 does resolve the
problem" because it was burried in a several hundred character long
line.  My apologies.

					- Ted
