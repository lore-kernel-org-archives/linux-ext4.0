From: Anton Blanchard <anton@samba.org>
Subject: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Wed, 4 Jan 2017 16:18:08 +1100
Message-ID: <20170104161808.5ad7b4fd@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: jack@suse.cz, Michael Ellerman <mpe@ellerman.id.au>, Benjamin
 Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras
 <paulus@samba.org>, Stephen Rothwell <sfr@canb.auug.org.au>, axboe@fb.com
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-ext4.vger.kernel.org

Hi,

I'm consistently seeing ext4 filesystem corruption using a mainline
kernel. It doesn't take much to trigger it - download a ppc64le Ubuntu
cloud image, boot it in KVM and run:

sudo apt-get update
sudo apt-get dist-upgrade
sudo reboot

And it never makes it back up, dying with rather severe filesystem
corruption.

I've narrowed it down to:

64e1c57fa474 ("ext4: Use clean_bdev_aliases() instead of iteration")
e64855c6cfaa ("fs: Add helper to clean bdev aliases under a bh and use it")
ce98321bf7d2 ("fs: Remove unmap_underlying_metadata")

Backing these patches out fixes the issue.

Anton
